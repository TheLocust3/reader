import React from 'react';
import styled from '@emotion/styled';

import { colors } from '../../constants';
import { Item } from '../../models/item';

const Container = styled.div`
  height: 100px;

  padding-top: 10px;
  padding-left: 10px;
  padding-right: 10px;

  background-color: white;

  cursor: pointer;

  &:hover {
    background-color: ${colors.whiteHover};
  }

  &:active {
    background-color: ${colors.whiteActive};
  }
`;

const ContainerInner = styled.div`
  height: 99px;

  padding-left: 20px;
  padding-right: 20px;

  border-bottom: 1px solid ${colors.black};
`;

const Title = styled.div`
  font-size: 18px;
  color: ${colors.black};
`

const Description = styled.div`
  padding-top: 5px;
  padding-left: 5px;
  padding-right: 5px;

  font-size: 14px;
  color: ${colors.black2};
`

interface Props {
  item: Item
}

function FeedItem({ item }: Props) {
  return (
    <Container>
      <ContainerInner>
        <Title>{item.title}</Title>
        <Description>{item.description}</Description>
      </ContainerInner>
    </Container>
  );
}

export default FeedItem;
