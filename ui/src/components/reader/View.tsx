import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from '@emotion/styled';

import Icon from '../common/Icon';
import Menu from '../common/Menu';
import FeedItem from './FeedItem';

import { Item } from '../../models/item';
import { Board } from '../../models/board';
import Boards from '../../api/boards';
import UserFeeds from '../../api/user-feeds';
import { colors } from '../../constants';

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
`;

const MoreButton = styled.div`
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
  feedId: string | undefined;
  boardId: string | undefined;
  title: string;
  items: Item[];
  boards: Board[];
}

function View({ feedId, boardId, title, items, boards }: Props) {
  const navigate = useNavigate();

  const [showMenu, setShowMenu] = useState<Boolean>(false);

  let showMore = feedId !== undefined || boardId !== undefined;
  let deleteItem = "";
  if (feedId !== undefined) {
    deleteItem = "Delete Feed";
  } else if (boardId !== undefined) {
    deleteItem = "Delete Board";
  }

  const onDeleteItemClick = () => {
    const reset = () => {
      setShowMenu(false);
      navigate('/');
    }

    if (feedId !== undefined) {
      UserFeeds.remove(feedId)
        .then(() => reset())
        .catch(() => reset());
    } else if (boardId !== undefined) {
      Boards.remove(boardId)
        .then(() => reset())
        .catch(() => reset());
    }
  }

  useEffect(() => {
    const listener = () => {
      setShowMenu(false);
    };

    document.addEventListener("click", listener);
    return () => document.removeEventListener("click", listener)
  }, []);

  return (
    <div>
      <Toolbar>
        <Title>{title}</Title>

        <More style={{ visibility: showMore ? "visible" : "hidden" }}>
          <MoreButton onClick={(event) => { event.stopPropagation(); setShowMenu(!showMenu) }}><Icon icon="more_vert" size="1.65em" /></MoreButton>

          <Menu show={showMenu} items={[{ text: deleteItem, onClick: onDeleteItemClick }]} />
        </More>
      </Toolbar>
      <Spacer />

      {items.map((item) => {
        return (
          <div>
            <FeedItem key={item.id} item={item} boards={boards} />
          </div>
        );
      })}
    </div>
  );
}

export default View;
