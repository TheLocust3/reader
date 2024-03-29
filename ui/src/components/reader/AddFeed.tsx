import React, { useState, useEffect } from 'react';
import styled from '@emotion/styled';

import { Card, Submit, Textbox } from 'central';

import Feeds from '../../api/feeds';
import UserFeeds from '../../api/user-feeds';

const Title = styled.div`
  padding-top: 5px;
  padding-bottom: 25px;

  font-size: 22px;
`;

const ErrorLabel = styled.div`
  height: 20px;

  font-size: 14px;
`;

const Label = styled.div`
  padding-bottom: 3px;
`;

const Spacer = styled.div`
  height: 10px;
`;

interface Props {
  onSubmit: () => void;
  show: Boolean
}

function AddFeed({ onSubmit, show }: Props) {
  const [source, setSource] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    if (!show) {
      setSource('');
      setError('');
    }
  }, [show]);
  
  const _onSubmit = async (event: any) => {
    event.preventDefault();

    try {
      await Feeds.create(source);
      await UserFeeds.add(source);
      onSubmit();
    } catch (e) {
      console.log(e)
      setError("Failed to create feed");
    }
  }

  return (
    <Card style={{ width: "300px", height: "200px" }}>
      <Title>Add Feed</Title>

      <form onSubmit={_onSubmit}>
        <Label>URL:</Label>
        <Textbox type="text" onChange={(event) => setSource(event.target.value)} value={source} required />
        <Spacer />
        
        <ErrorLabel>{error}</ErrorLabel>

        <Submit>Add</Submit>
        <input type="submit" style={{ display: "none" }} />
      </form>
    </Card>
  );
}

export default AddFeed;
