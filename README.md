Change in meaning of .dockerignore with and without buildkit

To reproduce:

```
./test.sh
```

Current output:
```
$ ./test.sh 
Sending build context to Docker daemon  74.24kB
Step 1/5 : FROM alpine
 ---> a24bb4013296
Step 2/5 : COPY . /foo
 ---> c148c40401e3
Step 3/5 : RUN rm -rf /foo/.git
 ---> Running in e5897b89c4a1
Removing intermediate container e5897b89c4a1
 ---> 9b333458fe16
Step 4/5 : WORKDIR /foo
 ---> Running in c66d4397ee21
Removing intermediate container c66d4397ee21
 ---> 50be4e5d30fc
Step 5/5 : CMD find .
 ---> Running in 2bb7d1a0ec1f
Removing intermediate container 2bb7d1a0ec1f
 ---> 59aa58dae0ad
Successfully built 59aa58dae0ad
Successfully tagged without-buildkit:latest
[+] Building 0.5s (9/9) FINISHED                                                                                                                                  
 => [internal] load .dockerignore                                                                                                                            0.0s
 => => transferring context: 34B                                                                                                                             0.0s
 => [internal] load build definition from Dockerfile                                                                                                         0.0s
 => => transferring dockerfile: 34B                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/alpine:latest                                                                                             0.0s
 => CACHED [1/4] FROM docker.io/library/alpine                                                                                                               0.0s
 => [internal] load build context                                                                                                                            0.0s
 => => transferring context: 3.38kB                                                                                                                          0.0s
 => [2/4] COPY . /foo                                                                                                                                        0.1s
 => [3/4] RUN rm -rf /foo/.git                                                                                                                               0.3s
 => [4/4] WORKDIR /foo                                                                                                                                       0.0s
 => exporting to image                                                                                                                                       0.0s
 => => exporting layers                                                                                                                                      0.0s
 => => writing image sha256:ff57f2c7a14d2dcaefd4cfbafee7d71f061a055fdfa127e42b667a028d35e03b                                                                 0.0s
 => => naming to docker.io/library/with-buildkit                                                                                                             0.0s
--- without-buildkit	2020-07-22 16:19:04.000000000 +0100
+++ with-buildkit	2020-07-22 16:19:04.000000000 +0100
@@ -1,6 +1,7 @@
 .
 ./b
 ./b/a
+./b/a/dir1
 ./test.sh
 ./README.md
 ./.dockerignore
The build contexts differ
```

There are 2 things in the filesystem:
- b/a/dir1: an empty directory
- b/a/file1: an empty file

The .dockerignore has:
```
!b/a/file1
b/a/file*
!b/a/dir1
b/a/dir*
```

Without buildkit: neither the empty file nor the empty directory are included.

With buildkit: the empty directory `/b/a/dir1` is included.

