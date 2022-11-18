import React, { useState } from 'react';
import styled from '@emotion/styled';

import Card from '../common/Card';
import Submit from '../common/Submit';
import Textbox from '../common/Textbox';

import Boards from '../../api/boards';

const Title = styled.div`
  padding-top: 5px;
  padding-bottom: 30px;

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
}

function AddFeed({ onSubmit }: Props) {
  const [name, setName] = useState('');
  const [error, setError] = useState('');
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
        <Textbox type="text" onChange={(event) => setName(event.target.value)} required />
        <Spacer />
        
        <ErrorLabel>{error}</ErrorLabel>

        <Submit>Add</Submit>
        <input type="submit" style={{ display: "none" }} />
      </form>
    </Card>
  );
}

export default AddFeed;
