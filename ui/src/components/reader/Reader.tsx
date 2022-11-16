import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import styled from '@emotion/styled';

import Sidebar from './Sidebar';
import View from './View';
import Add from './Add';

import { Feed } from '../../models/feed';
import { Item } from '../../models/item';
import { Board } from '../../models/board';
import Boards from '../../api/boards';
import UserFeeds from '../../api/user-feeds';
import Feeds from '../../api/feeds';
import { colors } from '../../constants';

const Root = styled.div`
  display: flex;

  width: 100%;
  height: 100%;
`;

const SidebarPane = styled.div`
  min-width: 250px;
  z-index: 10;

  background-color: white;
  border-right: 1px solid ${colors.black};
`;

const MainPane = styled.div`
  width: 100%;
`;

const AddPane = styled.div`
  position: absolute;
  bottom: 15px;
  right: 15px;
`;

type State = { feedId: string | undefined, boardId: string | undefined } | undefined;

function Reader() {
  const params = useParams();
  const feedId = params.feedId;
  const boardId = params.boardId;

  const current : State = { feedId: feedId, boardId: boardId };
  const [last, setLast] = useState<State>(undefined);

  const [boards, setBoards] = useState<Board[]>([]);
  const [feeds, setFeeds] = useState<Feed[]>([]);
  const [items, setItems] = useState<Item[]>([]);
  const [title, setTitle] = useState<string>("");

  if (JSON.stringify(current) !== JSON.stringify(last)) { // structural equality
    setLast(current);
    
    Boards.all().then((lists) => setBoards(lists));
    UserFeeds.all().then((feeds) => setFeeds(feeds));

    if (boardId !== undefined) {
      Boards.get(boardId).then((board) => setTitle(board.name));
      Boards.items(boardId).then((items) => setItems(items));
    } else if (feedId !== undefined) {
      Feeds.get(feedId).then((feed) => setTitle(feed.title));
      Feeds.items(feedId).then((items) => setItems(items));
    } else {
      setTitle("All Feeds");
      UserFeeds.items().then((items) => setItems(items));
    }
  }

  return (
    <Root>
      <SidebarPane>
        <Sidebar boards={boards} feeds={feeds} />
      </SidebarPane>

      <MainPane>
        <View title={title} items={items} />
      </MainPane>

      <AddPane>
        <Add />
      </AddPane>
    </Root>
  );
}

export default Reader;
