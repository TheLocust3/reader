import { apiHost } from '../constants';
import { Feed } from '../models/feed';
import Users from './users';

interface AllFeedsResponse {
  feeds: Feed[];
}

interface FeedResponse {
  feed: Feed;
}

const UserFeeds = {
  async all(): Promise<Feed[]> {
    const response = await fetch(
      `${apiHost}/user_feeds/`,
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: AllFeedsResponse = await response.json();
      return json.feeds
    } else {
      throw new Error(`UserFeeds.all - failed to fetch`);
    }
  },

  async add(source: string): Promise<void> {
    const response = await fetch(
      `${apiHost}/user_feeds/`,
      {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        },
        body: JSON.stringify({ uri: source })
      }
    );

    if (!response.ok) {
      throw new Error(`UserFeeds.create(${source}) - failed to fetch`);
    }
  },

  async remove(id: string): Promise<void> {
    const response = await fetch(
      `${apiHost}/user_feeds/${id}`,
      {
        method: "DELETE",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (!response.ok) {
      throw new Error(`UserFeeds.delete(${id}) - failed to fetch`);
    }
  }
}

export default UserFeeds;