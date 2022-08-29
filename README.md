# Puppet Module for zram_generator

## Description
Installs and configures [zram_generator](https://github.com/systemd/zram-generator)

## Example

```puppet
zram_generator::zram{'zram1':
  zram_size         => 'ram / 2',
}
```

This will create a `/dev/zram1` device half the size of available RAM and activate it.


## Reference

See [REFERENCE.md](REFERENCE.md) for full details of parameters.


