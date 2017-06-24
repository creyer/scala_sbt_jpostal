# scala_sbt_jpostal #

This docker image creates a container containing the latest Oracle Java 8 and
includes the latest versions of scala and sbt in the image also. 

It also includes a build of [libpostal](https://github.com/openvenues/libpostal)
and its java binding [jpostal](https://github.com/openvenues/jpostal)

# Usage #

Any projects that wants to use jpostal will need to set their
`java.library.path` to `/jpostal/src/main/jniLibs`

Also the NLP data location will be set to where ever the env variable `LIBPOSTAL_DATA`
is set to in the `Dockerfile`. Default being: `/postal/libpostaldata`
