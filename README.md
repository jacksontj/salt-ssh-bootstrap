# Salt-ssh Master bootstrap
I've set up a few salt installs, and made a variety of configurations for people to use.
While doing so I've been asked many times about the tradeoffs for various setups.

I initially addressed these when I gave a talk at [SaltConf15](https://www.slideshare.net/ThomasJackson4/salt-stack-at-web-scale-better-stronger-faster) which covered a few options for master setups. In addition to reading up them, the goal here is to have a simple salt-ssh setup which can *build* the environments for you to play with them.

## What are the setups?
Currently there are effectively 5 viable salt-master configurations.

1. Single-master per minion
2. N failover-masters per minion
3. Multi-master
4. Multi-layer masters
5. Clustered masters

### (1) Single-master per minion
This is the most basic salt-master setup (in fact its the default!).

##### Pros
- Single job-publish location
- Guraranteed consistency on the master (there's only one!)
- Simplest setup

##### Cons
- The master is a single point of failure (SPOF)
- Vertical scale of the master


### (2) N failover-masters per minion
This simply adds a failover option to the minion, such that when communications break between the minion and its master it will failover to another master. This can be used to effetively maintain a "standby" master which all the minions fail-over to in case of a failure.

##### Pros
- High-availability from the minion perspective (with the failover time)
- Eventual consistency on the master (relying on master_job_cache and a remote *_roots)

##### Cons
- Job publishing requires knowing which master the minion is connected to

### (3) Multi-master
For this setup we have each minion connect to all of the masters. This solves the issues around job publishing (since each minion is attached to all), it also solves the failover time issue for minions upon master failure.

##### Pros
- Single job-publish location
- Eventual consistency on the master (relying on master_job_cache and a remote *_roots)

##### Cons
- Vertical scale of the master (each master still has every minion connected to it)

### (4) Multi-layer masters
For this setup we use the `salt-syndic` daemon to syndicate publishes and returns from one layer of top-level masters to an "access" layer of masters. This lets us scale the publishing layer independantly from the access layer-- effectively unblocking us from horizonally scaling.

##### Pros
- Single job-publish location
- Eventual consistency on the master (relying on master_job_cache and a remote *_roots)
- Horizontal scaling of access layer of masters (which is where the majority of load is)

##### Cons
- Full-mesh connectivity between the publish and access layers of masters
- (Implementation-issue) -- syndics seem a bit flaky as of this writing.

### (5) Clustered masters
This is a variation on #4 where we collapse the publish and access layers. This can be done using `syndic_mode=cluster` on syndics. This is still an experimental (and undocumented) feature.

##### Pros
- Single job-publish location
- Eventual consistency on the master (relying on master_job_cache and a remote *_roots)
- Horizontal scaling of access layer of masters (which is where the majority of load is)
- Each master "looks" like a normal salt-master

##### Cons
- Full-mesh connectivity between masters (only for publish and some returns)
- (Implementation-issue) -- syndics seem a bit flaky as of this writing.


## Why salt-ssh?
When running a *real* salt install, it is helpful to manage salt using salt-ssh as it
lets you harness the power of salt's state system without having a circular dependancy.

Feel free to copy/modify/etc. any of the configuration/setup in this repo for any of your
setups. If you have modifications you've made, or alternative setups that you prefer please
let me know and we can work on potentially integrating them.
