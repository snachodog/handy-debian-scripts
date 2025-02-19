# Handy Debian Scripts

A collection of scripts designed to simplify tasks on Debian-based systems.

## Getting Started

Clone the repository:

```
git clone https://github.com/snachodog/handy-debian-scripts.git
```
Navigate to the directory:
```
cd handy-debian-scripts
```

Make the scripts executable:
```
chmod +x *.sh
```

Run a script:

```
./script-name.sh
```

## Scripts

### `ip_address_fix.sh`

A script to fix IP address-related issues. Specifically resolves Docker not being able to pull containers with the default setup by setting the device nameservers to IPv4 `8.8.8.8` and `1.1.1.1`

### `update_yacreader_library.sh`

A script to update the YACReader library.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
