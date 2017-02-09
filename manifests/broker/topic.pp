# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define: kafka::broker::topic
#
# This private class is meant to be called from `kafka::broker`.
# It manages the creation of topics on the kafka broker
#
define kafka::broker::topic(
  $ensure             = '',
  $zookeeper          = '',
  $replication_factor = 1,
  $partitions         = 1,
  $log_retention_ms   = undef
) {

  $_zookeeper          = "--zookeeper ${zookeeper}"
  $_replication_factor = "--replication-factor ${replication_factor}"
  $_partitions         = "--partitions ${partitions}"

  $_log_retention_ms = $log_retention_ms ? {
      undef       => "",
      default     => "--config retention.ms=${log_retention_ms}",
  }

  if $ensure == 'present' {
    exec { "create topic ${name}":
      path    => '/usr/bin:/usr/sbin/:/bin:/sbin:/opt/kafka/bin',
      command => "kafka-topics.sh --create ${_zookeeper} ${_replication_factor} ${_partitions} --topic ${name} ${_log_retention_ms}",
      unless  => "kafka-topics.sh --list ${_zookeeper} | grep -x ${name}",
    }
  }
}
