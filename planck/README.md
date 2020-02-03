# Using these tarballs

```
version=2.24.0
cd /opt
cat planck-$version-buster-i386.tar.gz | gunzip | tar x
ln -sf /opt/planck-$version/bin/planck /usr/local/bin/
ln -sf /opt/planck-$version/bin/plk /usr/local/bin/
ln -sf /opt/planck-$version/share/man/man1/planck.1 /usr/local/share/man/man1/
ln -sf /opt/planck-$version/share/man/man1/plk.1 /usr/local/share/man/man1/
apt-get install -y libjavascriptcoregtk-4.0 libglib2.0 libzip4 libcurl4 libicu63
```

## i386 performance notes

On a Dell netbook (Intel Atom 1.6GHz, dual core), startup performance is very slow (on Debian Buster):

```
$ time planck -e '(+ 1 1)'
2

real	0m18.440s
user	0m18.913s
sys	0m0.342s
```

Subsequent expressions evaluate instantly.

This startup performance might be due to Debian's decision to use the CLoop interpreter (non-JIT, non-ASM)
in JavaScriptCore in order to provide compatibility for pre-SSE2 i386 machines:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930935#47

> Ok, this patch disables SSE2 and forces Webkit to use CLoop, the C-based JavaScript interpreter (instead of using JIT or the asm-based intepreter). That's the one used when the CPU is unknown or not supported.

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=931052

https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=931052;filename=webkit2gtk-2.24.2-1_2.24.2-2.diff;msg=5

```diff
-# The 32-bit x86 build requires SSE2
+# Use the CLoop Javascript interpreter and disable the JIT. This is
+# slow but it is the most compatible solution for old (non-SSE2) CPUs.
 ifneq (,$(filter $(DEB_HOST_ARCH),i386))
-	CFLAGS += -msse2 -mfpmath=sse
+	EXTRA_CMAKE_ARGUMENTS += -DENABLE_JIT=OFF -DENABLE_C_LOOP=ON
 endif
```

For comparison, clojure's startup time is much faster on the same hardware:

```
$ time clojure -e '(+ 1 1)'
2

real	0m7.902s
user	0m13.091s
sys	0m0.835s
```

Hardware details:

```
# cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU N270   @ 1.60GHz
stepping	: 2
microcode	: 0x218
cpu MHz		: 858.303
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon pebs bts cpuid aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 xtpr pdcm movbe lahf_lm dtherm
bugs		:
bogomips	: 3192.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU N270   @ 1.60GHz
...
```
