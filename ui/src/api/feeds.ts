import { apiHost } from '../constants';
import { Feed } from '../models/feed';
import { Item } from '../models/item';
import Users from './users';

interface AllFeedsResponse {
  feeds: Feed[];
}

interface FeedResponse {
  feed: Feed;
}

interface ItemsResponse {
  items: Item[];
}

const Feeds = {
  async all(): Promise<Feed[]> {
    const response = await fetch(
      `${apiHost}/feeds/`,
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
      throw new Error(`Feeds.all - failed to fetch`);
    }
  },

  async get(source: string): Promise<Feed> {
    const response = await fetch(
      `${apiHost}/feeds/${source}`,
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: FeedResponse = await response.json();
      return json.feed;
    } else {
      throw new Error(`Feeds.get(${source}) - failed to fetch`);
    }
  },

  async items(source: string): Promise<Item[]> {
    const response = await fetch(
      `${apiHost}/feeds/${source}/items`,
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: ItemsResponse = await response.json();
      return json.items;
    } else {
      throw new Error(`Feeds.get(${source}) - failed to fetch`);
    }
  },

  async create(source: string): Promise<void> {
    const response = await fetch(
      `${apiHost}/feeds/`,
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
      throw new Error(`Feeds.create(${source}) - failed to fetch`);
    }
  },

  async remove(source: string): Promise<void> {
    const response = await fetch(
      `${apiHost}/feeds/${source}`,
      {
        method: "DELETE",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (!response.ok) {
      throw new Error(`Feeds.delete(${source}) - failed to fetch`);
    }
  }
}

export default Feeds;