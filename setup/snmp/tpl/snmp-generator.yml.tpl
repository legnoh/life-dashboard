modules:
  ${SNMP_EXPORTER_MODULE_NAME}:
    walk:
      - yrhCpuUtil5sec
      - yrhCpuUtil1min
      - yrhCpuUtil5min
      - yrfRevision
      - yrhInboxTemperature
      - yrfUpTime
      - yrhMemoryUtil
      - ifInOctets
      - ifOutOctets
    version: 3
    auth:
      username: ${SNMP_USERNAME}
      security_level: authPriv
      password: ${SNMP_PASSWORD}
      auth_protocol: SHA
      priv_protocol: AES
      priv_password: ${SNMP_PRIV_PASSWORD}
      context_name: ${SNMP_CONTEXT_NAME}
