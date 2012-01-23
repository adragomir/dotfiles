#!/usr/bin/env bash

# install Oracle JDK6 alternatives to OpenJDK 6 and Oracle JDK7

ORACLE_JAVA=/usr/lib/jvm/jdk1.6.0_29

sudo update-alternatives --install /usr/bin/java java $ORACLE_JAVA/bin/java 1100 \
--slave /usr/bin/javac javac $ORACLE_JAVA/bin/javac \
--slave /usr/bin/javaws javaws $ORACLE_JAVA/bin/javaws \
--slave /usr/bin/jar jar $ORACLE_JAVA/bin/jar \
--slave /usr/bin/jexec jexec $ORACLE_JAVA/jre/lib/jexec \
--slave /usr/bin/keytool keytool $ORACLE_JAVA/jre/bin/keytool \
--slave /usr/share/man/man1/keytool.1.gz keytool.1.gz $ORACLE_JAVA/man/man1/keytool.1 \
--slave /usr/bin/orbd orbd $ORACLE_JAVA/jre/bin/orbd \
--slave /usr/share/man/man1/orbd.1.gz orbd.1.gz $ORACLE_JAVA/man/man1/orbd.1 \
--slave /usr/bin/pack200 pack200 $ORACLE_JAVA/jre/bin/pack200 \
--slave /usr/share/man/man1/pack200.1.gz pack200.1.gz $ORACLE_JAVA/man/man1/pack200.1 \
--slave /usr/bin/policytool policytool $ORACLE_JAVA/jre/bin/policytool \
--slave /usr/share/man/man1/policytool.1.gz policytool.1.gz $ORACLE_JAVA/man/man1/policytool.1 \
--slave /usr/bin/rmid rmid $ORACLE_JAVA/jre/bin/rmid \
--slave /usr/share/man/man1/rmid.1.gz rmid.1.gz $ORACLE_JAVA/man/man1/rmid.1 \
--slave /usr/bin/rmiregistry rmiregistry $ORACLE_JAVA/jre/bin/rmiregistry \
--slave /usr/share/man/man1/rmiregistry.1.gz rmiregistry.1.gz $ORACLE_JAVA/man/man1/rmiregistry.1 \
--slave /usr/bin/servertool servertool $ORACLE_JAVA/jre/bin/servertool \
--slave /usr/share/man/man1/servertool.1.gz servertool.1.gz $ORACLE_JAVA/man/man1/servertool.1 \
--slave /usr/bin/tnameserv tnameserv $ORACLE_JAVA/jre/bin/tnameserv \
--slave /usr/share/man/man1/tnameserv.1.gz tnameserv.1.gz $ORACLE_JAVA/man/man1/tnameserv.1 \
--slave /usr/bin/unpack200 unpack200 $ORACLE_JAVA/jre/bin/unpack200 \
--slave /usr/share/man/man1/unpack200.1.gz unpack200.1.gz $ORACLE_JAVA/man/man1/unpack200.1
