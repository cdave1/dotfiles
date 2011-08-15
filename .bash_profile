# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

JAVA_HOME=/usr/share/jdk1.6.0_20

export JAVA_HOME

export M2_HOME=/usr/share/apache-maven/apache-maven-2.2.1
export M2=$M2_HOME/bin

PATH=$PATH:$JAVA_HOME/bin:$M2:$HOME/bin:/home/david/scala/bin:/home/david/android/android-sdk-linux_x86/tools:$HOME/firefox

export PATH
