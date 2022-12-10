const init = () => {
  if (window.location.protocol === "https:") {
    return `https://${window.location.hostname}/api`;
  } else {
    return `http://${window.location.hostname}:8080/api`;
  }
}

export const apiHost = init();

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
