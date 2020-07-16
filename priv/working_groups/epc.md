{
  "description": "External Process Communication, Interoperability and Robustness",
  "email": "epc@erlef.org",
  "formed": "2020-06-29",
  "gcal_url": null,
  "github": null,
  "members": [
    {
      "image": "members/susumu-yamazaki.jpg",
      "name": "Susumu Yamazaki"
    },
    {
      "image": "members/akash-hiremath.jpg",
      "name": "Akash Hiremath"
    },
    {
      "image": "members/graham-leva.jpg",
      "name": "Graham Leva"
    },
    {
      "image": "members/issac-yonemoto.jpg",
      "name": "Isaac Yonemoto"
    },
    {
      "image": "members/hideki-takase.jpg",
      "name": "Hideki Takase"
    }
  ],
  "name": "External Process Communication, Interoperability and Robustness",
  "slug": "epc"
}
---
EEF Fellowship Working Group
---

## Working Group Name

External Process Communication, Interoperability and Robustness

## Mission Statement

The mission of the working group is to facilitate and standardize interfaces and best practices for 
interoperability with programming languages outside of languages targetting the BEAM.  We believe 
that the efforts of the group will work towards facilitating the adoption of forward-looking 
technologies, promotion of the Erlang community as a good citizen in the broader technology ecosystem, 
and reduction of the barrier for adoption of BEAM-based solutions.

### Background

Interfacing with other languages is a common practice to harness efficiency or to provide extensability which 
cannot be realized by the Erlang VM alone.  There are two ways to achieve interoperability:  Ports and NIFs. 
Ports are more safe and robust than NIFs due to protection by OS process segregation.  On the other hand, 
NIFs have the potential to be more efficient than Ports, especially in the context of high performance computing, 
non-generalizable I/O systems, or bleeding edge/experimental hardware capabilities that are not ready for 
inclusion in mainline BEAM releases.

Some examples of systems which require or use custom interfaces, in various stages of maturity:

- Databases (e.g. PostgreSQL, MySql, Redis, SQLite)
- Robotics (e.g. Nerves, ROS)
- GPU compute (e.g. CUDA, OpenCL, ROCm)
- Machine learning (e.g. Tensorflow, PyTorch)
- Specialized networks (e.g. infiniband, virtio, RDMA)
- New storage capabilities (e.g. persistent memory)
- FPGA-based systems

Currently, there are several solutions created by our community that interface with other programming languages, 
but there are not necessarily guidelines or best practices for the creation of these solutions, a process to 
review them, or a formalized way to guide interested developers to help out with these solutions.  

Objectives of the working group are to survey current strategies, to support exploration and experimention for 
new best practices, to craft standards for evaluating different approaches, and to help balance exploration 
with reduction of community fragmentation and reduplicated effort. 

## Benefits to the community

* Serve as a place to discuss potential approaches and issues;
* Support libraries which wrap external programs or languages and have a clear direction;
* Advertise solutions which embody best practices and help them secure users and contributors;
* Help solutions identify points of improvement to increase their quality;
* Help solutions be generalizable across BEAM languages;
* Help our community coordinate to avoid reduplicated effort;

## Short term deliverables

* A survey of existing solutions for interoperability, and of solutions which use interoperability.
* A survey of existing interop code maintainers to understand pain points.
* Prototypes for systems which require custom interfaces.
* Proposals for API extensions of Ports and NIFs.

## Long term deliverables

* Guidelines to help focus the attention and effort of new NIF and Port developers with a view towards
  robustness, code clarity, and portability.
* Portable generic solutions for interacting with external processes, which are potentially more efficient 
  and robust than Ports and NIFs

## Why does this group require the Foundation

The topics include discussing and exploring different approaches on different platforms. To have a proper 
integration with Erlang Runtime requires insight and guidance from the core team. This requires backing 
from the foundation to bring the people together. The solution has immediate and tangible benefit to the 
community.

## Initial list of volunteers

* Susumu Yamazaki (ZACKY: a co-author of Pelemay https://github.com/zeam-vm/pelemay, nif-based computational acceleration)
* Akash Hiremath (author of Exile https://github.com/akash-akya/exile, an alternative to ports)
* Graham Leva (Software developer at NVIDIA, working on bringing Nerves to NVIDIA's embedded devices)
* Isaac Yonemoto (author of Zigler https://github.com/ityonemo/zigler, interoperability with Zig language)
* Hideki Takase (author of Cockatrice and RclEx https://github.com/tlk-emb/rclex interoperability with ROS)

-------