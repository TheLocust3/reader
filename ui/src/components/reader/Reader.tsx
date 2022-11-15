import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import styled from '@emotion/styled';

import Sidebar from './Sidebar';
import View from './View';
import Add from './Add';

import { Feed } from '../../models/feed';
import { Board } from '../../models/board';
import Boards from '../../api/boards';
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

function Reader() {
  const params = useParams();
  const feedId = params.feedId;
  const boardId = params.boardI;

  const [didMount, setDidMount] = useState<Boolean>(false);
  const [boards, setBoards] = useState<Board[]>([]);
  const [feeds, setFeeds] = useState<Feed[]>([]);

  if (!didMount) {
    setDidMount(true);
    
    Boards.all().then((lists) => setBoards(lists));
    setFeeds([]); // TODO: JK
  }

  return (
    <Root>
      <SidebarPane>
        <Sidebar boards={boards} feeds={feeds} />
      </SidebarPane>

      <MainPane>
        <View
          title="All Feeds"
          items={[
            { id: "1", title: "Article title", description: "Article description", link: "https://www.google.com/" },
            { id: "2", title: "Article title 2", description: "Article description", link: "https://www.google.com/" }
          ]} />
      </MainPane>

      <AddPane>
        <Add />
      </AddPane>
    </Root>
  );
}

export default Reader;
