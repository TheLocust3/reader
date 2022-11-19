import React from 'react';
import styled from '@emotion/styled';

import { colors } from '../../constants';
import { Item } from '../../models/item';

const Container = styled.a`
  display: block;
  max-height: 110px;

  padding-top: 10px;
  padding-left: 10px;
  padding-right: 10px;

  text-decoration: none;
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
  max-height: 70px;
  overflow: hidden;

  padding-left: 20px;
  padding-right: 20px;
  padding-bottom: 30px;

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
    <Container href={item.link} target="_blank">
      <ContainerInner>
        <Title>{item.title}</Title>
        <Description dangerouslySetInnerHTML={{__html: item.description}} />
      </ContainerInner>
    </Container>
  );
}

export default FeedItem;
