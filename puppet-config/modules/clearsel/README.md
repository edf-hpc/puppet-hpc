# hpc_conman

#### Table of Contents

1. [Overview](#overview)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Limitations](#limitations)

### Overview

Purge sel list of bmc

### Setup Requirements

This module needs a customized configuration file
to access every bmc

### Usage

```
class{ "::clearsel::server":
}
```

### Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

