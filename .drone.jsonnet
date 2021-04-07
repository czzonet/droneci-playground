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
    'echo "Building koodisto *********************"',
    'echo ALL_BEGIN',
    'export COMMAND_BEGIN=$$(date +%s)',
    'npm run build',
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

// Drone pipelines
[
  {
    kind: 'pipeline',
    name: 'pipeline-droneci-trip',
    steps: [
      buildApps(),
      messageDingtalk(),
    ],
    trigger: {
      branch: ['master'],
      event: ['push', 'pull_request'],
    },
  },
]
