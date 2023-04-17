import React, { useState, useEffect } from 'react';
import styled from '@emotion/styled';

import { Card, Submit, Textbox } from 'central';

import Boards from '../../api/boards';

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
  show: Boolean;
}

function AddFeed({ onSubmit, show }: Props) {
  const [name, setName] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    if (!show) {
      setName('');
      setError('');
    }
  }, [show]);

  const _onSubmit = async (event: any) => {
    event.preventDefault();

    try {
      await Boards.create(name);
      onSubmit();
    } catch {
      setError("Failed to create board");
    }
  }

  return (
    <Card style={{ width: "300px", height: "200px" }}>
      <Title>Add Board</Title>

      <form onSubmit={_onSubmit}>
        <Label>Name:</Label>
        <Textbox type="text" onChange={(event) => setName(event.target.value)} value={name} required />
        <Spacer />
        
        <ErrorLabel>{error}</ErrorLabel>

        <Submit>Add</Submit>
        <input type="submit" style={{ display: "none" }} />
      </form>
    </Card>
  );
}

export default AddFeed;
