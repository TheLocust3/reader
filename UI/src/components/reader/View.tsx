import React from 'react';
import styled from '@emotion/styled';

import FeedItem from './FeedItem';

import { colors } from '../../constants';
import { Item } from '../../models/item';

const Toolbar = styled.div`
  position: fixed;
  display: flex;
  align-items: center;

  width: 100%;
  height: 50px;

  padding-left: 5px;
  padding-right: 5px;

  border-bottom: 1px solid ${colors.black};

  box-shadow: 0px 0px 5px ${colors.lightBlack};
`;

const Title = styled.div`
  font-size: 20px;
  color: ${colors.black};
`;

const Spacer = styled.div`
  height: 50px;
`

interface Props {
  title: string;
  items: Item[];
}

function View({ title, items }: Props) {
  return (
    <div>
      <Toolbar>
        <Title>{title}</Title>
      </Toolbar>
      <Spacer />

      {items.map((item) => {
        return (
          <div>
            <FeedItem key={item.id} item={item} />
          </div>
        );
      })}
    </div>
  );
}

export default View;
