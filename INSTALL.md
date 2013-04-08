Installing R and RHadoop on a small CentOS 6 cluster
====================================================

Using csshX to install R and RHadoop on the cluster.

    csshX --login root --hosts ~/cloudera/cluster/hosts.txt

Install R:

    yum -y --enablerepo=epel install R R-devel
    R CMD javareconf

Start R REPL and install some packages:

    install.packages(c('Rcpp', 'RJSONIO', 'itertools', 'digest'), repos="http://cran.revolutionanalytics.com", INSTALL_opts=c('--byte-compile') )
    install.packages(c('functional', 'stringr', 'plyr'), repos="http://cran.revolutionanalytics.com", INSTALL_opts=c('--byte-compile') )
    install.packages(c('rJava'), repos="http://cran.revolutionanalytics.com" )
    install.packages(c('randomForest'), repos="http://cran.revolutionanalytics.com" )
    install.packages(c('reshape2'), repos="http://cran.revolutionanalytics.com" )

Then dnload RHadoop and install

    git clone git://github.com/RevolutionAnalytics/rmr2.git
    R CMD INSTALL --byte-compile rmr2/pkg/

Set some environ vars in `.bashrc`:

    export HADOOP_HOME=/usr/lib/hadoop
    export HADOOP_CMD=/usr/bin/hadoop
    export HADOOP_STREAMING=/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.2.0.jar

Make sure to source the new variables before continuing.

Installed `rhdfs`:

    git clone git://github.com/RevolutionAnalytics/rhdfs.git
    R CMD INSTALL --byte-compile rhdfs/pkg/

Done.
