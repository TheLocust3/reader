import { apiHost } from '../constants';
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
    const response = await fetch(
      `${apiHost}/boards/`,
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
    const response = await fetch(
      `${apiHost}/boards/${id}`,
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
    const response = await fetch(
      `${apiHost}/boards/${id}/items`,
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
    const response = await fetch(
      `${apiHost}/boards/`,
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
    const response = await fetch(
      `${apiHost}/boards/${id}`,
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
  }
}

export default Boards;