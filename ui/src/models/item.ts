export interface Item {
  id: string;
  from_feed: string;
  title: string;
  description: string;
  link: string;
  read: Boolean
}

export interface ItemEntity {
  item: Item;
  metadata: { read: Boolean };
}
