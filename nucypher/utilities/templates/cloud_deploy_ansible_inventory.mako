all:
  children:
    nucypher:
      children:
        ${deployer.network}:
          children:
            nodes:
              vars:
                network_name: "${deployer.network}"
                geth_options: "--${deployer.chain_name}"
                geth_dir: '/home/nucypher/geth/.ethereum/${deployer.chain_name}/'
                geth_container_geth_datadir: "/root/.ethereum/${deployer.chain_name}"
                nucypher_container_geth_datadir: "/root/.local/share/geth/.ethereum/${deployer.chain_name}"
                etherscan_domain: ${deployer.chain_name}.etherscan.io
                ansible_python_interpreter: /usr/bin/python3
                ansible_connection: ssh
                NUCYPHER_KEYRING_PASSWORD: ${deployer.config['keyringpassword']}
                NUCYPHER_WORKER_ETH_PASSWORD: ${deployer.config['ethpassword']}
                nucypher_image: ${deployer.config['nucypher_image']}
                blockchain_provider: ${deployer.config['blockchain_provider']}
                node_is_decentralized: ${deployer.nodes_are_decentralized}
                %if deployer.config.get('use-prometheus'):
                prometheus: --prometheus --metrics-port ${deployer.PROMETHEUS_PORT}
                %else:
                prometheus:
                %endif
                %if deployer.config.get('seed_node'):
                SEED_NODE_URI: ${deployer.config['seed_node']}
                %else:
                SEED_NODE_URI:
                %endif
                %if deployer.config.get('sentry_dsn'):
                SENTRY_DSN: ${deployer.config['sentry_dsn']}
                %endif
                wipe_nucypher_config: ${wipe_nucypher}
              hosts:
                %for node in nodes:
                ${node.publicaddress}:
                  %for attr in node.provider_deploy_attrs:
                  ${attr.key}: ${attr.value}
                  %endfor
                  % if node.blockchain_provider:
                  blockchain_provider: {{node.blockchain_provider}}
                  %endif
                  %if node.nucypher_image:
                  nucypher_image: ${node.nucypher_image}
                  %endif
                  %if node.sentry_dsn:
                  sentry_dsn: ${node.sentry_dsn}
                  %endif
                %endfor
