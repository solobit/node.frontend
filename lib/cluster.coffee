cluster = require('cluster')

Cluster = cluster('./app')
Cluster.use(cluster.logger('logs'))
Cluster.use(cluster.stats())
Cluster.use(cluster.pidfiles('pids'))
Cluster.use(cluster.cli())
Cluster.use(cluster.repl(8888))
Cluster.listen(3000);
