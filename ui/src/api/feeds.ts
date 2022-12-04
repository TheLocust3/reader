import { request } from './util';
import { Feed } from '../models/feed';
import { Item, ItemEntity } from '../models/item';
import Users from './users';

interface FeedResponse {
  feed: Feed;
}

interface ItemsResponse {
  items: ItemEntity[];
}

const Feeds = {
  async get(source: string): Promise<Feed> {
    const response = await request(
      `/feeds/${encodeURIComponent(source)}`,
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
    const response = await request(
      `/feeds/${encodeURIComponent(source)}/items`,
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
      throw new Error(`Feeds.get(${source}) - failed to fetch`);
    }
  },

  async create(source: string): Promise<void> {
    const response = await request(
      "/feeds",
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
    const response = await request(
      `/feeds/${encodeURIComponent(source)}`,
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