{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'wildfly',
        rules: [
          {
            alert: 'HighPercentageOfErrorResponses',
            expr: |||
              increase(wildfly_undertow_error_count_total{}[5m]) / increase(wildfly_undertow_request_count_total{}[5m]) * 100 > %(alertsErrorRequestErrorRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Large percentage of requests are resulting in 5XX responses.',
              description: |||
                The percentage of error responses is {{ printf "%%.2f" $value }} which is higher than {{%(alertsErrorRequestErrorRate)s }}.
              ||| % $._config,
            },
          },
          {
            alert: 'HighNumberOfRejectedSessionsForDeployment',
            expr: |||
              increase(wildfly_undertow_rejected_sessions_total{}[5m]) > %(alertsErrorRejectedSessions)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Large number of sessions are being rejected for a deployment.',
              description: |||
                Deployemnt {{ $labels.deployment }} is exceeding the threshold for rejected sessions {{ printf "%%.0f" $value }} is higher than %(alertsErrorRejectedSessions)s.
              ||| % $._config,
            },
          },
        ],
      },
    ],
  },
}
