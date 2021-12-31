import React from 'react';
import styled from '@emotion/styled';

import { colors } from '../constants';

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
  padding-left: 18px;
  padding-top: 5px;
  padding-bottom: 5px;

  font-size: 18px;
`;

const ClickableHeader = styled.div`
  padding-left: 18px;
  padding-top: 5px;
  padding-bottom: 5px;

  font-size: 18px;

  cursor: pointer;

  &:hover {
    color: black;
  }
`;

const Item = styled.div`
  padding-left: 28px;

  font-size: 15px;

  cursor: pointer;

  &:hover {
    color: black;
  }
`;

function Sidebar() {
  return (
    <Container>
      <ClickableHeader>All</ClickableHeader>
      <ClickableHeader>Read Later</ClickableHeader>

      <Spacer />
      <Divider />
      <Spacer />
      <Spacer />

      <Header>Lists</Header>
      <Spacer />
      <div>
        <Item>Read Later</Item>
      </div>

      <Spacer />
      <Spacer />
      <Divider />
      <Spacer />

      <Header>Feeds</Header>
      <Spacer />
      <div>
        <Item>All</Item>
      </div>
    </Container>
  );
}

export default Sidebar;
