{
  "title": "Exposed EPMD: A Hidden Security Risk for RabbitMQ and the BEAM Ecosystem",
  "authors": ["The Security Working Group"],
  "slug": "epmd-public-exposure",
  "category": "security",
  "tags": ["security", "epmd", "cybersecurity", "rabbitmq"],
  "datetime": "2024-12-17T15:15:48.619713Z"
}
---
EPMD, essential for Erlang and RabbitMQ clustering, is often exposed online—posing hidden security risks and requiring quick mitigation steps.
---

The Erlang Port Mapper Daemon (EPMD) is a built-in component that helps Erlang-based applications (including RabbitMQ) discover each other’s distribution ports for clustering. Although EPMD itself isn’t directly dangerous, its exposure on the public internet often signals that Erlang Distribution ports are also exposed. This creates a serious security risk: if attackers find these distribution ports, they can potentially join your cluster, run arbitrary code, and compromise your systems. Recent scans have revealed over 85,000 instances of publicly accessible EPMD, with roughly half associated with RabbitMQ servers.

If left unsecured, exposed Erlang Distribution ports let attackers gain a foothold in your system. Fortunately, mitigation steps are straightforward: disable Erlang Distribution if you’re not clustering, or restrict it behind a firewall and proper network configuration—and ensure Erlang Distribution is never exposed to untrusted networks.

## TL;DR

**Check if you’re exposed:**
- Run a port scan:  
  ```bash
  nmap -A -sT -p 4369 [Your Public IP]
  ```  
  If the output shows:  
  ```
  PORT     STATE SERVICE VERSION
  4369/tcp open  epmd    Erlang Port Mapper Daemon
  | epmd-info: 
  |   epmd_port: 4369
  |   nodes: 
  |_    rabbit: 25672
  ```
  Your EPMD port is exposed, indicating your Erlang Distribution ports may be discoverable as well.

**For Erlang/Elixir users:**

- **Use a firewall or security group rules to restrict external access**:  
  Close all ports except those explicitly required for your application. Restricting access to only essential services reduces your overall attack surface and helps mitigate various security risks beyond just EPMD exposure.

- **Bind distribution to a non-public interface**:  
  In `vm.args`:
  ```bash
  -kernel inet_dist_use_interface '{127, 0, 0, 1}' -env ERL_EPMD_ADDRESS="127.0.0.1"
  ```
  Ensuring that distribution ports are only accessible via localhost or a private network interface further reduces the attack surface.

- **Enable epmd-less mode in your releases**: Both Erlang and Elixir tooling allows you to use the Erlang Distribution without exposing EPMD. Rebar3 enables this option by default. In Elixir, [it is part of your generated release configuration](https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-epmd-less-deployment).

- **Remove or avoid using `-name` or `-sname` if you don’t need clustering**:  
  If you’re not clustering nodes, don’t assign them a name. Without -name or -sname, the node won’t just be absent from EPMD—it disables Erlang distribution entirely. This means your application won’t attempt to listen on distribution ports at all, further reducing the attack surface.

**For RabbitMQ users:**
- RabbitMQ runs on Erlang and uses EPMD behind the scenes. Even if you never interact directly with Erlang, you may still be affected if Erlang Distribution ports are exposed.
- Check the RabbitMQ networking documentation to learn how to identify exposed ports and close them:  
  [https://www.rabbitmq.com/docs/networking#epmd](https://www.rabbitmq.com/docs/networking#epmd)  
- The Erlang Ecosystem Foundation’s security hardening guide explains what EPMD is, which ports Erlang, and how to close them down:  
  [https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/distribution](https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/distribution)

## What is EPMD and How Does it Work?

Erlang was designed for concurrency, distribution, and fault tolerance. To support clustering (distributed Erlang nodes connecting and communicating seamlessly), Erlang relies on EPMD. EPMD runs as a small daemon that keeps track of nodes and their associated distribution ports. When a node starts with `-name` or `-sname`, it registers with EPMD on port 4369.

In a controlled environment—such as an internal network—this works well. EPMD makes it easy for nodes to discover each other, connect, and form clusters. However, when EPMD is open to the public internet, it provides a roadmap for attackers to find and target the Erlang Distribution ports themselves—where the real danger lies.

**Key points:**
- EPMD listens on port 4369 by default.
- It’s assumed that EPMD is only reachable from within a trusted network.
- Many Erlang/Elixir build tools and release pipelines (like Rebar3, Mix, and Distillery releases) enable EPMD by default.

## Why is Exposing EPMD (and Erlang Distribution) a Bad Idea?

### Risk of Unauthorized Cluster Access Through Erlang Distribution

EPMD’s purpose is to help Erlang nodes discover each other’s distribution ports. When exposed, it effectively provides a roadmap to these ports. Erlang clustering uses a “cookie” as a shared secret, but this cookie is not a robust authentication mechanism—just a sanity check to prevent accidental connections. If an attacker can guess or brute-force it, they can join your cluster.

Once inside, an attacker can run arbitrary Erlang Remote Procedure Calls (RPCs), giving them full control over the application and potentially the underlying system. While no widespread internet-based attacks on Erlang Distribution have been publicly documented, the theoretical risk is real. EPMD exposure makes it significantly easier for attackers to find and exploit these distribution ports.

A known brute-force approach and related tools are described here:

* [Erlang distribution RCE and a cookie bruteforcer](https://insinuator.net/2017/10/erlang-distribution-rce-and-a-cookie-bruteforcer/)
* [erl-matter](https://github.com/gteissier/erl-matter?tab=readme-ov-file)

### Scope of the Problem

Shodan (a search engine for internet-connected devices) reveals over 85,000 publicly accessible EPMD instances. Among them, around 40,000 are associated with RabbitMQ.
Top countries hosting exposed EPMD endpoints include China (18,444), the United States (15,771), and Germany (10,263). Major cloud hosting platforms (DigitalOcean, Hetzner, Aliyun, Tencent, OVH, Amazon, and others) also host significant numbers of exposed instances. This typically occurs when users fail to implement proper firewall rules, or lack a full understanding of Erlang distribution’s security implications.

[![World Map showing number of exposed EPMD instances](/images/posts/epmd-public-exposure/world-map.png) {: .responsive-image}](https://www.shodan.io/search/report?query=product%3A%22Erlang+Port+Mapper+Daemon%22)

### Not Just Erlang Developers at Risk

RabbitMQ, a popular message broker built on Erlang, runs EPMD and Erlang Distribution under the hood. Many RabbitMQ users may not be aware that these ports are exposed. Without proper network hygiene, this can leave their systems vulnerable, even if they never use Erlang directly.

## How to Secure Your Erlang Distribution (and EPMD)

**1. Use a Firewall or Restricted Network Interfaces**

If you don’t need external clustering, ensure EPMD and the Erlang Distribution ports aren’t exposed:

- Bind Erlang Distrubution and EPMD to localhost or a private network interface. In `vm.args`, specify:
  ```bash
  -kernel inet_dist_use_interface '{127, 0, 0, 1}' -env ERL_EPMD_ADDRESS "127.0.0.1"
  ```
- Deploy firewalls, security groups, or network ACLs to ensure that no unintended ports—including 4369—are exposed to untrusted networks, leaving only the ports you explicitly intend to serve publicly accessible.

**2. Mitigation is Simple**

Applying a strict firewall policy, configuring loopback interfaces, and removing unnecessary distribution settings can resolve the issue. Close all ports not explicitly required by your application—simply closing port 4369 (EPMD) is not enough, as Erlang distribution can use additional, dynamically assigned ports. After adjusting your firewall and configuration, verify that only your intended services are accessible:

```bash
nmap -sT -p0- 127.0.0.1 [Public IP]
```

If your application only needs HTTPS (443) open, for example, ensure that the result shows closed for all ports except the ones you have intentionally whitelisted, such as:

```bash
PORT     STATE  SERVICE VERSION
443/tcp   open  https
```

**3. Follow Best Practices from the Community**

- **RabbitMQ**: The official networking guide details how to identify and close EPMD and distribution ports.
- **Erlang Ecosystem Foundation**: The security hardening guide explains what EPMD and Erlang Distribution are, which ports are used, and how to secure them.

## Conclusion

EPMD exposure is a warning sign. It indicates that Erlang Distribution ports—the true target for potential attackers—may also be accessible. By securing or disabling EPMD where unnecessary and ensuring Erlang Distribution ports are not exposed to untrusted networks, you can prevent unauthorized access, reduce risk, and keep your applications safe.
