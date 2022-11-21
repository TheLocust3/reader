import { request } from './util';
import { Board } from '../models/board';
import { Item } from '../models/item';
import Users from './users';

interface AllBoardsResponse {
  boards: Board[];
}

interface BoardResponse {
  board: Board;
}

interface ItemsResponse {
  items: Item[];
}

const Boards = {
  async all(): Promise<Board[]> {
    const response = await request(
      "/boards/",
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: AllBoardsResponse = await response.json();
      return json.boards
    } else {
      throw new Error(`Boards.all - failed to fetch`);
    }
  },

  async get(id: string): Promise<Board> {
    const response = await request(
      `/boards/${id}`,
      {
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (response.ok) {
      const json: BoardResponse = await response.json();
      return json.board;
    } else {
      throw new Error(`Boards.get(${id}) - failed to fetch`);
    }
  },

  async items(id: string): Promise<Item[]> {
    const response = await request(
      `/boards/${id}/items`,
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
      throw new Error(`Boards.get(${id}) - failed to fetch`);
    }
  },

  async create(name: string): Promise<void> {
    const response = await request(
      `/boards`,
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
      throw new Error(`Boards.create(${name}) - failed to fetch`);
    }
  },

  async remove(id: string): Promise<void> {
    const response = await request(
      `/boards/${id}`,
      {
        method: "DELETE",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (!response.ok) {
      throw new Error(`Boards.delete(${id}) - failed to fetch`);
    }
  },

  async addItem(boardId: string, itemId: string): Promise<void> {
    const response = await request(
      `/boards/${boardId}/items`,
      {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        },
        body: JSON.stringify({ item_id: itemId })
      }
    );

    if (!response.ok) {
      throw new Error(`Boards.addItem(${boardId}, ${itemId}) - failed to fetch`);
    }
  },

  async removeItem(boardId: string, itemId: string): Promise<void> {
    const response = await request(
      `/boards/${boardId}/items/${encodeURIComponent(itemId)}`,
      {
        method: "DELETE",
        headers: {
          'Content-Type': 'application/json',
          'authentication': `Bearer ${Users.token()}`
        }
      }
    );

    if (!response.ok) {
      throw new Error(`Boards.removeItem(${boardId}, ${itemId}) - failed to fetch`);
    }
  }
}

export default Boards;