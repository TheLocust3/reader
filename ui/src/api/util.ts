import { apiHost } from '../constants';

export const request = async (uri: string, options: any) => {
  const response = await fetch(`${apiHost}${uri}`, options);
  if (response.status === 403) {
    window.location.href = "/login";
  }

  return response;
}
