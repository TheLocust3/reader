import React from 'react';
import styled from '@emotion/styled';

import Icon from '../Icon';
import FeedItem from './FeedItem';

import { colors } from '../../constants';
import { Item } from '../../models/item';

const Toolbar = styled.div`
  position: fixed;
  display: flex;
  align-items: center;

  background-color: white;

  width: 100%;
  height: 50px;

  padding-left: 10px;
  padding-right: 10px;

  border-bottom: 1px solid ${colors.black};

  box-shadow: 0px 0px 3px ${colors.lightBlack};

  justify-content: space-between
`;

const More = styled.div`
  padding-top: 5px;
  padding-right: 275px;

  cursor: pointer;
  color: ${colors.black};

  &:hover {
    color: black;
  }
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

        <More><Icon icon="more_vert" size="1.65em" /></More>
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
