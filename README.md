# TeamBox2 Vagrant (TBV2)

A vagrant development environment focused on PHP development with Symfony 5 


## How To Use

To use it, download and install [Vagrant](https://www.vagrantup.com), [VirtualBox](https://www.virtualbox.org/) and [Git](https://git-scm.com/). Clone this repository and run:

```bash
git clone https://github.com/mladjom/tbv2.git
```

```bash
cd tbv2
```

```bash
vagrant plugin install vagrant-hostsupdater --local
```

```bash
vagrant up
```

For ssh access:
```bash
vagrant ssh
```

> **Note:** Default preconfigured host is tbv2.test.

## Minimum System requirements

- [Vagrant](https://www.vagrantup.com) 2.2.10+
- [Virtualbox](https://www.virtualbox.org) 6.1.14
- [Git](https://git-scm.com/) 
- 2GB+ of RAM
- Virtualisation ( VT-X ) enabled in the BIOS ( Windows/Linux )
- Hyper-V turned off ( Windows )

## Software included

- Ubuntu 20.04 LTS (Focal Fossa)
- NGINX
- PHP 8 
- MySQL 8
- phpMyAdmin 
- Composer
- Symfony CLI

## Adding a New Site

This package ships with a **custom.example** and **hosts.yml.example** file in the root of the project.

You must rename those files to just **custom** and **hosts.yml**

```bash
cp custom.example custom
cp hosts.yml.example hosts.yml
```

> **Note:** Make sure you have hidden files shown on your system.

You can add virtual hosts to NGINX by editing `custom` file. The `DocumentRoot` of the new virtual host will be a directory within the
`www/` folder matching the `ServerName` you specified. The `Directory` maps to a folder on the host machine.

    server {
        listen 80;
         listen [::]:80;
  
         server_name example.com;
  
         root /var/www/example;
         index index.html;
  
         location / {
                 try_files $uri $uri/ =404;
         }
    }

In order to access new vagrant hosts via your local browser you will need to edit your hosts file `hosts.yml` like this:

    ---
    - example.test

To update you will need to reload vagrant with provision flag.

```bash
vagrant reload --provision
```

Create `/www/example` folder. Open it in an editor to start making changes to your site.

When it's done, visit  [http://example.test](http://example.test).

### NGINX
The NGINX server is available at [192.168.33.20](http://192.168.33.20)

### MySQL
Externally the MySQL server is available at port 8889, and when running on the VM it is available as a socket or at port 3306 as usual.  
**Username**: root  
**Password**: toor

### PhpMyadmin
PhpMyadmin is available at [192.168.33.20/phpmyadmin](http://192.168.33.10/phpmyadmin)  
**Username**: root  
**Password**: toor

### Composer

Composer binary is installed globally (to `/usr/local/bin`), so you can simply call `composer` from any directory.
