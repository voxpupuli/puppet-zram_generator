# Puppet Module for zram_generator

[![Build Status](https://github.com/voxpupuli/puppet-zram_generator/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-zram_generator/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-zram_generator/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-zram_generator/actions/workflows/release.yml)
[![Puppet Forge Version](http://img.shields.io/puppetforge/v/puppet/zram_generator.svg)](https://forge.puppetlabs.com/puppet/zram_generator)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppet/zram_generator.svg)](https://forge.puppetlabs.com/puppet/zram_generator)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/puppet/zram_generator.svg)](https://forge.puppetlabs.com/puppet/zram_generator)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-zram_generator)
[![Apache v2 License](https://img.shields.io/github/license/voxpupuli/puppet-zram_generator.svg)](LICENSE)
[![Donated by CERN](https://img.shields.io/badge/donated%20by-CERN-0033a0.svg)](#transfer-notice)

## Description
Installs and configures [zram_generator](https://github.com/systemd/zram-generator)

## Example

```puppet
zram_generator::zram{'zram1':
  zram_size         => 'ram / 2',
}
```

This will create a `/dev/zram1` device half the size of available RAM and activate it.

## Hiera Example

A set of `zram_generator::zram` can be loaded from hiera:

```yaml
zram_generator::zrams:
  zram0:
    fs_type: 'ext4'
    mount_point: '/run/mount'
  zram1:
    zram_size: 1024
```

## Reference

See [REFERENCE.md](REFERENCE.md) for full details of parameters.


