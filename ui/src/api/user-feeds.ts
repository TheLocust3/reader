import { request } from './util';
import { Feed } from '../models/feed';
import { Item, ItemEntity } from '../models/item';
import Users from './users';

interface AllFeedsResponse {
  feeds: Feed[];
}

interface ItemsResponse {
  items: ItemEntity[];
}

const UserFeeds = {
  async all(): Promise<Feed[]> {
    const response = await request(
      "/user_feeds/",
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

  async items(): Promise<Item[]> {
    const response = await request(
      "/user_feeds/items",
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
      return json.items.map(({ item, metadata}) => ({ ...item, ...metadata }));
    } else {
      throw new Error(`UserFeeds.items - failed to fetch`);
    }
  },

  async recently_read_items(): Promise<Item[]> {
    const response = await request(
      "/user_feeds/items/read",
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
      return json.items.map(({ item, metadata}) => ({ ...item, ...metadata }));
    } else {
      throw new Error(`UserFeeds.items - failed to fetch`);
    }
  },

  async add(source: string): Promise<void> {
    const response = await request(
      "/user_feeds",
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
    const response = await request(
      `/user_feeds/${encodeURIComponent(id)}`,
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