const { request } = require('@octokit/request');
const { createActionAuth } = require('@octokit/auth-action');

const REPOSITORY = process.env.GITHUB_REPOSITORY;
const BRANCH_NAME = process.argv[2];
const PROJECT_NAME = process.argv[3];

const auth = createActionAuth();

const requestWithAuth = request.defaults({
  request: {
    hook: auth.hook,
  },
});

async function isProjectExists(owner, repo, projectName) {
  const { data: projects } = await requestWithAuth(
    'GET /repos/{owner}/{repo}/projects',
    {
      owner,
      repo,
      mediaType: {
        previews: ['inertia'],
      },
    }
  );

  return projects.some((project) => project.name === projectName);
}

async function createProject(repository) {
  const [owner, repo] = repository.split('/');

  const projectExists = await isProjectExists(owner, repo, PROJECT_NAME);

  if (!projectExists) {
    console.log(`Creating project tracker for ${BRANCH_NAME} branch`);

    const { data: project } = await requestWithAuth(
      'POST /repos/{owner}/{repo}/projects',
      {
        owner,
        repo,
        name: PROJECT_NAME,
        body: `Tracker for ${BRANCH_NAME} branch`,
        mediaType: {
          previews: ['inertia'],
        },
      }
    );

    await createProjectColumn(project.id, 'To do');
    await createProjectColumn(project.id, 'In progress');
    await createProjectColumn(project.id, 'Done');
  }
}

async function createProjectColumn(projectId, columnName) {
  await requestWithAuth('POST /projects/{project_id}/columns', {
    project_id: projectId,
    name: columnName,
    mediaType: {
      previews: ['inertia'],
    },
  });
}

if (REPOSITORY) {
  createProject(REPOSITORY);
}
