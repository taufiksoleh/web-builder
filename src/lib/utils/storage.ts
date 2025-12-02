import type { Project, CanvasState } from '$lib/types';
import { nanoid } from 'nanoid';

const STORAGE_KEY = 'web-builder-projects';
const CURRENT_PROJECT_KEY = 'web-builder-current-project';

export function saveProject(name: string, canvasState: CanvasState): Project {
  const projects = getProjects();
  const currentProjectId = getCurrentProjectId();

  let project: Project;

  if (currentProjectId) {
    // Update existing project
    const existingProject = projects.find((p) => p.id === currentProjectId);
    if (existingProject) {
      project = {
        ...existingProject,
        name,
        updatedAt: Date.now(),
        canvasState,
      };
      const index = projects.findIndex((p) => p.id === currentProjectId);
      projects[index] = project;
    } else {
      // Create new project if not found
      project = createNewProject(name, canvasState);
      projects.push(project);
    }
  } else {
    // Create new project
    project = createNewProject(name, canvasState);
    projects.push(project);
  }

  localStorage.setItem(STORAGE_KEY, JSON.stringify(projects));
  setCurrentProjectId(project.id);

  return project;
}

function createNewProject(name: string, canvasState: CanvasState): Project {
  return {
    id: nanoid(),
    name,
    createdAt: Date.now(),
    updatedAt: Date.now(),
    canvasState,
  };
}

export function getProjects(): Project[] {
  const data = localStorage.getItem(STORAGE_KEY);
  return data ? JSON.parse(data) : [];
}

export function getProject(id: string): Project | null {
  const projects = getProjects();
  return projects.find((p) => p.id === id) || null;
}

export function deleteProject(id: string): void {
  const projects = getProjects().filter((p) => p.id !== id);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(projects));

  if (getCurrentProjectId() === id) {
    localStorage.removeItem(CURRENT_PROJECT_KEY);
  }
}

export function getCurrentProjectId(): string | null {
  return localStorage.getItem(CURRENT_PROJECT_KEY);
}

export function setCurrentProjectId(id: string): void {
  localStorage.setItem(CURRENT_PROJECT_KEY, id);
}

export function loadCurrentProject(): Project | null {
  const id = getCurrentProjectId();
  return id ? getProject(id) : null;
}

export function autoSave(canvasState: CanvasState): void {
  const currentProjectId = getCurrentProjectId();
  if (currentProjectId) {
    const project = getProject(currentProjectId);
    if (project) {
      saveProject(project.name, canvasState);
    }
  }
}
