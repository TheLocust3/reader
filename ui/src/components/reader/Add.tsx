import React from 'react';
import styled from '@emotion/styled';

import { colors } from '../../constants';

import Icon from '../Icon';

const Container = styled.div`
  height: 50px;
  width: 50px;

  border: 1px solid ${colors.black};
  border-radius: 100%;

  box-shadow: 0px 3px 10px ${colors.lightBlack};

  display: flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;

  color: ${colors.black};

  cursor: pointer;
  user-select: none;

  &:hover {
    background-color: ${colors.whiteHover};
  }

  &:active {
    background-color: ${colors.whiteActive};
  }
`;

function Add() {
  return (
    <Container>
      <Icon icon="add" size="26px" />
    </Container>
  );
}

export default Add;
