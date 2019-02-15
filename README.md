# Maxima Mirror Auto-Updater

I created this repository to see how difficult it would be to set up an automated git mirror; turns out, this isn't too tricky at all!
This repository mirrors the upstream [Maxima Sourceforge Repository](http://maxima.sourceforge.net/) to a [github clone](https://github.com/jgoldfar/maxima-clone); to avoid having to deal with hosting, I simply use Travis to execute those instructions.
To do that, we'll need push access to my clone to be granted to Travis.

1) Generate a new key (easier to revoke if compromised)

```shell
ssh-keygen -t rsa -b 4096 -C "jgoldfar+docker@gmail.com" -f id_rsa -P ""
cat id_rsa.pub
```

2) Copy the public key to a [deploy key on GitHub](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys).

3) Encrypt the private key and store the encrypted version on the server:

```shell
travis encrypt-file id_rsa --add
rm id_rsa id_rsa.pub
git add id_rsa .travis.yml
```
