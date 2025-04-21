{
  "title": "Erlang Ecosystem Foundation Becomes CVE Numbering Authority (CNA) for the Hex and BEAM Ecosystem",
  "authors": ["The Security Working Group"],
  "slug": "eef-cna-announcement",
  "category": "security",
  "tags": ["security", "cve", "cna", "vulnerability-disclosure"],
  "datetime": "2025-05-13T00:00:00.000000Z"
}
---
The Erlang Ecosystem Foundation has joined the CVE® Program as a CNA, making it
easier for the BEAM community to disclose and track vulnerabilities in Hex.pm
packages and core ecosystem projects.
---

The [Erlang Ecosystem Foundation CNA](https://cna.erlef.org/) has officially
joined the [CVE® Program](https://www.cve.org/) as an authorized
CVE Numbering Authority (CNA). This designation allows us to assign CVE IDs and
publish CVE Records for publicly disclosed cybersecurity vulnerabilities within
our defined scope, helping to improve security and transparency in the broader
open-source community.

## What is a CVE?
CVE stands for *Common Vulnerabilities and Exposures*. It's a global system for
identifying and cataloging publicly known security issues in software. Each CVE
ID is a unique identifier that makes it easier to talk about and fix
vulnerabilities. Being part of this program means we can help track and
coordinate security issues across the BEAM ecosystem in a standard, globally
recognized way.

## Scope of Coverage

Our CNA is responsible for assigning CVE IDs and publishing CVE Records for:

- All **active packages hosted on [Hex.pm](https://hex.pm/)**, *provided no more
  specific CNA exists for that package.*
- All active projects hosted under the following GitHub organizations:
  - [@elixir-lang](https://github.com/elixir-lang)
  - [@erlang](https://github.com/erlang)
  - [@erlef-cna](https://github.com/erlef-cna)
  - [@erlef](https://github.com/erlef)
  - [@gleam-lang](https://github.com/gleam-lang)
  - [@hexpm](https://github.com/hexpm)

You can always check if a package is covered by a more specific CNA via the
[List of CVE Partners](https://www.cve.org/PartnerInformation/ListofPartners).

## A Community Collaboration

This CNA is the result of a collaborative effort between the **Erlang/OTP**,
**Erlang Ecosystem Foundation**, **Elixir**, **Gleam**, and **Hex** communities.
Together, we are committed to supporting secure development practices across our
shared ecosystem.

## What’s Changing for Me?

With the Erlang Ecosystem Foundation now acting as a CNA, here’s what this means
for different members of our community:

- **Project Maintainers:** You can now request CVE IDs directly from us instead
  of going through MITRE. We also offer guidance and support throughout the
  disclosure process.
- **Security Reporters:** Submit vulnerability reports to us instead of MITRE.
  We’ll help facilitate communication with project maintainers and guide the
  process responsibly.
- **Tool Developers:** Expect more accurate, consistent, and ecosystem-specific
  CVE metadata, enabling improved security tooling and automation.
- **Ecosystem Users:** Over time, this will lead to better tooling support and
  increased visibility into the security posture of the packages you rely on.

## Coordinated Vulnerability Disclosure

If you are a project maintainer within our scope and need to request a CVE ID,
please reach out to **us directly** rather than contacting MITRE as you may have
done previously. As your CNA, we are here to guide you through the process. This
change replaces the default reporting path via MITRE for projects covered by our
CNA.

We offer dedicated **support for responsible vulnerability disclosure**—including
coordination and best practices—for all maintainers of projects covered by our
scope. Whether you're unsure how to handle a report or need help with wording a
disclosure, we’re here to assist.

For reporters: we strongly encourage you to follow the **Security Policy** of
the affected project when disclosing vulnerabilities. These can usually be found
in the project’s repository or package metadata.

If you're unable to reach the project team, or are unsure how to proceed, you’re
welcome to contact us us directly via [our contact page](https://cna.erlef.org/contact).


## About the CVE® Program

The mission of the CVE ® Program is to identify, define, and catalog publicly
disclosed cybersecurity vulnerabilities. There is one CVE Record for each
vulnerability in the catalog. The vulnerabilities are discovered then assigned
and published by organizations from around the world that have partnered with
the CVE Program. Partners publish CVE Records to communicate consistent
descriptions of vulnerabilities. Information technology and cybersecurity
professionals use CVE Records to ensure they are discussing the same issue, and
to coordinate their efforts to prioritize and address the vulnerabilities.

For more information, visit [cve.org](https://www.cve.org/About/Overview).

## Join Us in Making the Ecosystem Safer

As a community-driven CNA, we aim to support developers, security researchers,
and users in the Erlang, Elixir, and Gleam ecosystems. We are committed to
responsible vulnerability disclosure and improving the overall security posture
of open-source software.

🔗 **Learn more or get in touch:** [https://cna.erlef.org/](https://cna.erlef.org/)
