import React from 'react';
import { Link } from 'react-router-dom';
import styled from '@emotion/styled';

import { colors } from '../../constants';
import { Board } from '../../models/board';
import { Feed } from '../../models/feed';

const Container = styled.div`
  padding-top: 14px;
`;

const Divider = styled.hr`
  margin-left: 5px;
  margin-right: 5px;
  border: 0;
  border-top: 1px solid ${colors.black};
`;

const Spacer = styled.div`
  width: 100%;
  height: 8px;
`;

const Header = styled.div`
  padding-left: 20px;
  padding-top: 5px;
  padding-bottom: 5px;

  font-size: 18px;
`;

const ClickableHeader = styled(Link)`
  display: block;

  padding-left: 20px;
  padding-top: 5px;
  padding-bottom: 5px;

  text-decoration: none;
  font-size: 18px;
  color: ${colors.black};

  cursor: pointer;

  &:hover {
    text-decoration: none;
    color: black;
  }

  &:visited {
    text-decoration: none;
  }

  &:active {
    text-decoration: none;
  }
`;

const Item = styled(Link)`
  display: block;

  padding-left: 30px;

  text-decoration: none;
  font-size: 15px;
  color: ${colors.black};

  cursor: pointer;

  &:hover {
    text-decoration: none;
    color: black;
  }

  &:visited {
    text-decoration: none;
  }

  &:active {
    text-decoration: none;
  }
`;

interface Props {
  boards: Board[];
  feeds: Feed[];
  onAddFeedClick: () => void;
}

function Sidebar({ boards, feeds, onAddFeedClick }: Props) {
  const readLater = boards.filter((board) => board.name === "Read Later")[0];

  return (
    <Container>
      <ClickableHeader to={`/`}>All</ClickableHeader>
      {readLater !== undefined ? <ClickableHeader to={`/boards/${readLater.id}`}>Read Later</ClickableHeader> : <span />}

      <Spacer />
      <Divider />
      <Spacer />

      <Header>Boards</Header>
       <Spacer />
       <div>
         {boards.map((board) => {
           return <Item key={board.id} to={`/boards/${board.id}`}>{board.name}</Item>;
         })}
       </div>

      <Spacer />
      <Spacer />
      <Divider />
      <Spacer />

      <Header>Feeds</Header>
      <Spacer />
      <div>
        {feeds.map((feed) => {
          return <Item key={feed.source} to={`/feeds/${feed.source}`}>{feed.title}</Item>;
        })}
        <Item to='#' onClick={onAddFeedClick}>+ Add feed</Item>
      </div>
    </Container>
  );
}

export default Sidebar;
