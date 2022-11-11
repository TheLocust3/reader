import React from 'react';
import { Link } from 'react-router-dom';
import styled from '@emotion/styled';

import { colors } from '../../constants';
import { FeedList } from '../../models/feed-list';
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
  lists: FeedList[];
  feeds: Feed[];
}

function Sidebar({ lists, feeds }: Props) {
  return (
    <Container>
      <ClickableHeader to={`/`}>All</ClickableHeader>

      <Spacer />
      <Divider />
      <Spacer />

      <Header>Lists</Header>
      <Spacer />
      <div>
        {lists.map((list) => {
          return <Item key={list.id} to={`/lists/${list.id}`}>{list.name}</Item>;
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
      </div>
    </Container>
  );
}

export default Sidebar;
