// local featureBranchPattern = 'feature/*';

local buildApps() = {
  name: 'tsc编译',
  image: 'node:14',
  depends_on: ['clone'],
  // volumes:
  //   - name: cache
  //     path: /root/.m2
  commands: [
    'echo "Starting step: buildApps *********************"',
    'whoami',
    'pwd',
    'export ALL_BEGIN=$$(date +%s)',
    // Start actual jar building
    'echo "Building *********************"',
    'echo $ALL_BEGIN',
    'export COMMAND_BEGIN=$$(date +%s)',
    'npm run build',
    'export END=$$(date +%s)',
    'export DURATION=$$(($${END}-$${COMMAND_BEGIN}))',
    'echo Build duration $$(($$DURATION / 60)) minutes and $$(($$DURATION % 60)) seconds',

  ],
};

local messageDingtalk() = {
  name: '钉钉通知',
  image: 'guoxudongdocker/drone-dingtalk',
  depends_on: ['tsc编译'],
  settings: {
    token: {
      from_secret: 'dingding',
    },
    type: 'markdown',
    message_color: true,
    message_pic: true,
    sha_link: true,
  },
  when: {
    status: ['failure', 'success'],
  },
};

local simpleShell() = {
  name: 'shell',
  image: 'alpine',
  commands: [
    'whoami',
    'pwd',
    'ls -al',
  ],
};

local useCache() = {
  name: 'cache',
  image: 'alpine',
  volumes: [
    {
      name: 'cache',
      host: {
        path: '/drone/src/node_modules',
      },
    },
  ],
  commands: [
    'whoami',
    'pwd',
    'ls -al',
  ],
};

// Drone pipelines
[
  {
    kind: 'pipeline',
    name: 'platform-arm',
    platform: {
      os: 'linux',
      arch: 'arm64',
    },
    // node: {
    //   datacenter: 'A',
    // },
    steps: [
      simpleShell(),
      useCache(),
    ],
    trigger: {
      branch: ['master'],
      event: ['push', 'pull_request'],
    },
    volumes: [
      {
        name: 'cache',
        host: {
          path: '/Users/czz/Temp',
        },
      },
    ],
  },
]
