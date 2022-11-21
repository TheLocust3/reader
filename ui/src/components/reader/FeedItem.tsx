import React, { useState, useEffect } from 'react';
import styled from '@emotion/styled';

import Icon from '../common/Icon';
import Menu from '../common/Menu';

import Boards from '../../api/boards';
import { Item } from '../../models/item';
import { Board } from '../../models/board';
import { colors } from '../../constants';

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
`;

const ContainerInner = styled.div`
  max-height: 70px;

  padding-left: 20px;
  padding-right: 20px;
  padding-bottom: 30px;

  border-bottom: 1px solid ${colors.black};
`;

const TitleContainer = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  vertical-align: middle;
`;

const Title = styled.div`
  font-size: 18px;
  color: ${colors.black};
`

const Options = styled.div`
  color: ${colors.black};
`;

const OptionsItem = styled.span`
  padding-left: 7px;
  font-size: 1.5em;

  &:hover {
    color: black;
  }
`;

const Description = styled.div`
  display: block;
  max-height: 65px;
  overflow: hidden;

  padding-top: 5px;
  padding-left: 5px;
  padding-right: 5px;

  font-size: 14px;
  color: ${colors.black2};
`

interface Props {
  boardId: string | undefined;
  item: Item
  boards: Board[];
  refresh: () => void;
}

function FeedItem({ boardId, item, boards, refresh }: Props) {
  const [showMenu, setShowMenu] = useState<Boolean>(false);
  const showRemove = boardId !== undefined;

  useEffect(() => {
    const listener = () => {
      setShowMenu(false);
    };

    document.addEventListener("click", listener);
    return () => document.removeEventListener("click", listener)
  }, []);

  return (
    <Container href={item.link} target="_blank">
      <ContainerInner>
        <TitleContainer>
          <Title>{item.title}</Title>

          <Options>
            <OptionsItem onClick={(event) => { event.stopPropagation(); event.preventDefault(); setShowMenu(true); }}><Icon icon="add" /></OptionsItem>
            <OptionsItem style={{ display: showRemove ? "inline" : "none" }} onClick={(event) => {
              event.stopPropagation();
              event.preventDefault();
              if (boardId !== undefined) {
                Boards.removeItem(boardId, item.id);
                refresh();
              }
             }}><Icon icon="close" /></OptionsItem>

            <Menu
              show={showMenu}
              items={boards.map((board) => {
                return {
                  text: board.name,
                  onClick: async () => { setShowMenu(false); Boards.addItem(board.id, item.id) }
                };
              })}
              right={showRemove ? 40 : 15}
            />
          </Options>
        </TitleContainer>

        <Description dangerouslySetInnerHTML={{__html: item.description}} />
      </ContainerInner>
    </Container>
  );
}

export default FeedItem;
