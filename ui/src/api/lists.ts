import { apiHost } from '../constants';
import { FeedList } from '../models/feed-list';
import { Feed } from '../models/feed';
import Users from './users';

interface AllFeedListsResponse {
  feed_lists: FeedList[];
}

interface FeedListResponse {
  feed_list: FeedList;
  feeds: Feed[];
}

const Lists = {
  async all(): Promise<FeedList[]> {
    const response = await fetch(
      `${apiHost}/lists/`,
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: AllFeedListsResponse = await response.json();
      return json.feed_lists;
    } else {
      throw new Error(`Lists.all - failed to fetch`);
    }
  },

  async get(id: string): Promise<{ feedList: FeedList, feeds: Feed[] }> {
    const response = await fetch(
      `${apiHost}/lists/${id}`,
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: FeedListResponse = await response.json();
      return { feedList: json.feed_list, feeds: json.feeds };
    } else {
      throw new Error(`Lists.get(${id}) - failed to fetch`);
    }
  },

  async create(name: string): Promise<void> {
    const response = await fetch(
      `${apiHost}/lists/`,
      {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        },
        body: JSON.stringify({ name: name })
      }
    );

    if (!response.ok) {
      throw new Error(`Lists.create(${name}) - failed to fetch`);
    }
  },

  async remove(id: string): Promise<void> {
    const response = await fetch(
      `${apiHost}/lists/${id}`,
      {
        method: "DELETE",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (!response.ok) {
      throw new Error(`Lists.delete(${id}) - failed to fetch`);
    }
  }
}

export default Lists;