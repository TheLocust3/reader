import { Api } from 'central';

export const request = async (uri: string, options: any) => {
  return Api.Reader.request(uri, options);
}
