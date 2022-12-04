import { request } from './util';
import Users from './users';

const UserItems = {
  async setRead(itemId: string): Promise<void> {
    const response = await request(
      `/user_items/${encodeURIComponent(itemId)}/read`,
      {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (!response.ok) {
      throw new Error(`UserItems.setRead(${itemId}) - failed to fetch`);
    }
  }
}

export default UserItems;