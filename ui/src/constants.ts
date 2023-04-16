interface EndpointDefinition {
  root: string;
  api: string;
  central: string
}

const init = () : EndpointDefinition => {
  if (window.location.protocol === "https:") {
    return {
      root: `https://${window.location.hostname}/`,
      api: `https://${window.location.hostname}/api`,
      central: `https://central.jakekinsella.com/api`
    };
  } else {
    return {
      root: `http://${window.location.hostname}:3000`,
      api: `http://${window.location.hostname}:2000/api`,
      central: `http://localhost:3001`
    };
  }
}

const { root, api, central } = init();
export const apiHost = api;
export const login = `${central}/login?redirect=${encodeURIComponent(root)}`;

export const colors = {
  black: '#444',
  black2: '#666',
  lightBlack: '#999',
  lighterBlack: '#aaa',
  lightestBlack: '#bbb',

  whiteHover: '#f9f9f9',
  whiteActive: '#f1f1f1',

  lightGray: '#eeeeee',

  red: '#ef5350'
};
