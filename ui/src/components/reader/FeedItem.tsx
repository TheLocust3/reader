import React, { useState, useEffect, useRef } from 'react';
import { css } from '@emotion/css'
import styled from '@emotion/styled';
import sanitizeHtml from 'sanitize-html';

import Icon from '../common/Icon';
import Menu from '../common/Menu';

import Boards from '../../api/boards';
import UserItems from '../../api/user-items';
import { Item } from '../../models/item';
import { Feed } from '../../models/feed';
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

const readContainer = css`
  background-color: ${colors.whiteActive} !important;

  &:hover {
    background-color: ${colors.lightGray} !important;
  }
`;

const ContainerInner = styled.div`
  max-height: 70px;

  padding-left: 20px;
  padding-right: 20px;
  padding-bottom: 35px;

  overflow-y: hidden;

  border-bottom: 1px solid ${colors.black};
`;

const TitleContainer = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  vertical-align: middle;
`;

const Title = styled.div`
  max-width: 700px;

  font-size: 18px;
  color: ${colors.black};
`

const Subtitle = styled.div`
  max-width: 700px;

  font-size: 15px;
  color: ${colors.black2};

  padding-top: 2px;
  padding-bottom: 5px;
`

const Options = styled.div`
  color: ${colors.black};
`;

const OptionsItem = styled.span`
  padding-left: 12px;
  font-size: 1.4em;

  &:hover {
    color: black;
  }
`;

const removeIcon = css`
  &:hover {
    color: ${colors.red} !important;
  }
`;

const Description = styled.div`
  display: block;
  max-width: 700px;
  min-height: 60px;
  max-height: 60px;

  padding-top: 5px;
  padding-left: 5px;
  padding-right: 5px;

  font-size: 14px;
  color: ${colors.black2};
`

interface Props {
  boardId: string | undefined;
  item: Item;
  feeds: Feed[];
  boards: Board[];
  refresh: () => void;
}

function FeedItem({ boardId, item, feeds, boards, refresh }: Props) {
  const ref = useRef<HTMLAnchorElement>(null);

  const [showMenu, setShowMenu] = useState<Boolean>(false);
  const showRemove = boardId !== undefined;

  const [past, setPast] = useState<Boolean>(item.read);

  const feed = feeds.filter((feed) => feed.source === item.from_feed)[0]

  useEffect(() => {
    const listener = ({ key }: any) => {
      if (key === "Escape") {
        setShowMenu(false);
      }
    };

    document.addEventListener("keydown", listener);
    return () => document.removeEventListener("keydown", listener)
  }, []);

  useEffect(() => {
    const listener = () => {
      setShowMenu(false);
    };

    document.addEventListener("click", listener);
    return () => document.removeEventListener("click", listener);
  }, []);

  useEffect(() => {
    var _past = past; // be able to set past immediately

    const listener = () => {
      if (past || _past) {
        return;
      }

      const rect = ref.current?.getBoundingClientRect();
      if (rect !== undefined) {
        if (rect.bottom <= 50) { // TODO: JK toolbar height
          _past = true;
          setPast(true);
          UserItems.setRead(item.id)
        }
      }
    };

    document.addEventListener("scroll", listener);
    return () => document.removeEventListener("click", listener);
  }, [past, item]);

  return (
    <Container onClick={() => { setPast(true); UserItems.setRead(item.id) }} href={item.link} target="_blank" ref={ref} className={past ? readContainer : ''}>
      <ContainerInner>
        <TitleContainer>
          <Title>{sanitizeHtml(item.title, { allowedTags: [], disallowedTagsMode: 'discard' })}</Title>

          <Options>
            <OptionsItem onClick={(event) => { event.stopPropagation(); event.preventDefault(); setShowMenu(!showMenu); }}><Icon icon="add" /></OptionsItem>
            <OptionsItem className={removeIcon} style={{ display: showRemove ? "inline" : "none" }} onClick={(event) => {
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
              right={showRemove ? 40 : 10}
            />
          </Options>
        </TitleContainer>
        
        <Subtitle>{feed === undefined ? "" : feed.title}</Subtitle>

        <Description dangerouslySetInnerHTML={{__html: sanitizeHtml(item.description, { allowedTags: ['br'], disallowedTagsMode: 'discard' })}} />
      </ContainerInner>
    </Container>
  );
}

export default FeedItem;
