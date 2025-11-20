export type State = {
  isSidebarOpen: boolean;
};

const stateSource: State = {
  isSidebarOpen: false,
};

export const state = new Proxy(stateSource, {
  get(target, property: keyof State) {
    return target[property];
  },

  set(target, property: keyof State, value) {
    const oldValue = target[property];
    if (oldValue !== value) {
      target[property] = value;

      globalThis.dispatchEvent(
        new CustomEvent("state:set", {
          detail: { target, property, value, oldValue },
        }),
      );

      globalThis.dispatchEvent(
        new CustomEvent(`state:set:${property}`, {
          detail: { target, property, value, oldValue },
        }),
      );
    }

    return true;
  },
});

export function toggleSidebar() {
  state.isSidebarOpen = !state.isSidebarOpen;
}
