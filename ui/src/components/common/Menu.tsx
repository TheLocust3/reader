import React from 'react';
import styled from '@emotion/styled';

import { colors } from '../../constants';

const FloatingMenu = styled.div`
  position: relative;
  width: 100%;
  height: 100%;

  z-index: 11;
`;

const MenuContainer = styled.div`
  position: absolute;
  width: 125px;

  background-color: white;

  border: 1px solid ${colors.black};
  border-radius: 5px;
`;

const MenuItem = styled.div`
  padding-top: 10px;
  padding-bottom: 10px;
  padding-left: 15px;

  display: flex;

  border-radius: 5px;

  cursor: pointer;

  &:hover {
    background-color: ${colors.whiteHover};
  }

  &:active {
    background-color: ${colors.whiteActive};
  }
`;

interface Props {
  show: Boolean;
  items: { text: string, onClick: () => void }[];
  right?: number;
}

function Menu({ show, items, right = 5 }: Props) {
  return (
    <FloatingMenu>
      <MenuContainer style={{ visibility: show ? "visible" : "hidden", right: `${right}px` }}>
        {items.map(({text, onClick}) => {
          return <MenuItem onClick={(event) => { event.stopPropagation(); event.preventDefault(); onClick(); }}>{text}</MenuItem>
        })}
      </MenuContainer>
    </FloatingMenu>
  );
}

export default Menu;