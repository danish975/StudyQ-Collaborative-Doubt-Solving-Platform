-- 1. Insert Tags (tags[0] to tags[11])
INSERT INTO "Tag" (id, name, color) VALUES 
('tag_0', 'React', '#61dafb'),
('tag_1', 'Python', '#3776ab'),
('tag_2', 'Algorithms', '#f59e0b'),
('tag_3', 'Machine Learning', '#22c55e'),
('tag_4', 'Next.js', '#ffffff'),
('tag_5', 'System Design', '#a855f7'),
('tag_6', 'Databases', '#ef4444'),
('tag_7', 'JavaScript', '#f7df1e'),
('tag_8', 'TypeScript', '#3178c6'),
('tag_9', 'Docker', '#2496ed'),
('tag_10', 'AWS', '#ff9900'),
('tag_11', 'CSS', '#264de4')
ON CONFLICT (name) DO NOTHING;

-- 2. Insert Users (user1, user2, user3)
INSERT INTO "User" (id, email, name, reputation, role, bio, "updatedAt") VALUES 
('usr_1', 'alice@studyq.dev', 'Alice Chen', 1240, 'CONTRIBUTOR', 'Full-stack developer passionate about React and system design.', NOW()),
('usr_2', 'bob@studyq.dev', 'Bob Martinez', 890, 'STUDENT', 'CS undergrad exploring ML and algorithms.', NOW()),
('usr_3', 'carol@studyq.dev', 'Carol Davis', 2100, 'CONTRIBUTOR', 'Backend engineer specializing in databases and distributed systems.', NOW())
ON CONFLICT (email) DO NOTHING;

-- 3. Insert Questions (q1 to q5)
INSERT INTO "Question" (id, title, description, status, difficulty, views, "authorId", "updatedAt") VALUES 
('q_1', 'How does React Fiber architecture improve render performance?', 'I''ve been reading about React''s reconciliation process but I''m struggling to understand the exact mechanics of "incremental rendering" and how it prioritizes updates.

Specifically:
1. How does Fiber break work into units?
2. What determines priority of updates?
3. How does time-slicing actually work under the hood?

Can someone explain this with a clear example? I''ve read the official docs but they''re quite abstract.', 'RESOLVED', 'HARD', 342, 'usr_2', NOW()),

('q_2', 'Solving the N-Queens problem using backtracking in Python', 'I keep getting stuck in an infinite loop when trying to implement the safe check logic for diagonals.

Here''s my current approach:
```python
def is_safe(board, row, col, n):
    for i in range(col):
        if board[row][i] == 1:
            return False
    # Check upper diagonal
    # Check lower diagonal
    return True
```

What am I missing for the diagonal checks? Also, is there a more efficient approach than O(n²) checking?', 'UNANSWERED', 'HARD', 89, 'usr_1', NOW()),

('q_3', 'What''s the difference between useMemo and useCallback?', 'They seem to do the exact same thing (returning cached values) but the docs say one is for functions. Why can''t I just use useMemo for everything?

I''ve seen code like:
```tsx
const memoizedValue = useMemo(() => computeExpensive(a, b), [a, b]);
const memoizedCallback = useCallback(() => doSomething(a, b), [a, b]);
```

Aren''t these equivalent? When would I choose one over the other?', 'PARTIALLY_ANSWERED', 'MEDIUM', 567, 'usr_2', NOW()),

('q_4', 'How to design a URL shortener system at scale?', 'I''m preparing for system design interviews and need help understanding the complete architecture of a URL shortener like bit.ly.

Questions:
- How to generate unique short codes?
- How to handle billions of URLs?
- What caching strategy to use?
- How to handle analytics and click tracking?

Looking for a comprehensive answer covering all trade-offs.', 'UNANSWERED', 'HARD', 23, 'usr_3', NOW()),

('q_5', 'Understanding CSS Grid vs Flexbox — when to use which?', 'I keep going back and forth between Grid and Flexbox. Sometimes Grid feels like overkill for simple layouts, but Flexbox gets messy with complex ones.

Can someone give clear guidelines on:
1. When to use Grid vs Flexbox?
2. Can they be combined?
3. Performance differences?', 'RESOLVED', 'EASY', 890, 'usr_1', NOW())
ON CONFLICT (id) DO NOTHING;

-- 4. Connect Tags to Questions (Exactly matching the array indices in seed.ts)
INSERT INTO "_QuestionToTag" ("A", "B") VALUES 
('q_1', 'tag_0'), ('q_1', 'tag_7'),
('q_2', 'tag_1'), ('q_2', 'tag_2'),
('q_3', 'tag_0'), ('q_3', 'tag_8'),
('q_4', 'tag_5'), ('q_4', 'tag_6'),
('q_5', 'tag_11'), ('q_5', 'tag_7')
ON CONFLICT DO NOTHING;

-- 5. Insert Answers (a1 and two unnamed answers)
INSERT INTO "Answer" (id, content, "isAccepted", "authorId", "questionId", "updatedAt") VALUES
('ans_1', 'Great question! React Fiber is essentially a reimplementation of React''s core algorithm.

## How Fiber Works
Fiber introduces **incremental rendering**, which means the ability to split rendering work into chunks and spread it out over multiple frames.

### Key Concepts:
1. **Work Units**: Each fiber node represents a unit of work. React can pause, abort, or reuse work as needed.
2. **Priority Levels**: Updates are assigned priority — user interactions (high), data fetching (normal), offscreen rendering (low).
3. **Time-Slicing**: React checks if there''s remaining time in each frame (~16ms). If not, it yields to the browser.

The key insight is that Fiber maintains a **linked list** of fibers rather than a recursive call stack, allowing it to pause and resume at any point.', true, 'usr_3', 'q_1', NOW()),

('ans_2', 'CSS Grid and Flexbox serve different layout needs:

## Use Flexbox when:
- Laying out items in a **single direction** (row or column)
- You need items to **flex and fill** available space
- Building nav bars, card rows, centering content

## Use Grid when:
- You need **two-dimensional** layouts (rows AND columns)
- Building page-level layouts
- Complex, asymmetric designs

## Can they combine?
Absolutely! Use Grid for the page scaffold, Flexbox for component internals.

## Performance
Both are extremely fast in modern browsers. Grid may trigger slightly more layout calculations, but the difference is negligible.', true, 'usr_3', 'q_5', NOW()),

('ans_3', 'The key difference is what they memoize:

- **useMemo** memoizes the **return value** of a function
- **useCallback** memoizes the **function itself**

```tsx
// useMemo: caches the RESULT of calling the function
const sortedList = useMemo(() => sort(items), [items]);

// useCallback: caches the FUNCTION REFERENCE
const handleClick = useCallback(() => onClick(id), [id]);
```

Use `useCallback` when passing callbacks to optimized child components that rely on reference equality to prevent re-renders.', false, 'usr_1', 'q_3', NOW())
ON CONFLICT (id) DO NOTHING;

-- 6. Insert Votes
INSERT INTO "Vote" (id, type, "userId", "questionId", "answerId") VALUES 
('v_1', 'UPVOTE', 'usr_1', 'q_1', NULL),
('v_2', 'UPVOTE', 'usr_2', 'q_1', NULL),
('v_3', 'UPVOTE', 'usr_3', 'q_3', NULL),
('v_4', 'UPVOTE', 'usr_1', 'q_5', NULL),
('v_5', 'UPVOTE', 'usr_2', NULL, 'ans_1')
ON CONFLICT DO NOTHING;

-- 7. Insert Comments
INSERT INTO "Comment" (id, content, "authorId", "answerId", "questionId", "updatedAt") VALUES 
('c_1', 'This is an excellent explanation! The linked list analogy really helped me understand.', 'usr_2', 'ans_1', NULL, NOW()),
('c_2', 'Could you also add an example with concurrent features like Suspense?', 'usr_1', NULL, 'q_1', NOW())
ON CONFLICT (id) DO NOTHING;

-- 8. Insert Badges
INSERT INTO "UserBadge" (id, name, icon, "userId") VALUES 
('b_1', 'Top Helper', '🏆', 'usr_3'),
('b_2', 'First Answer', '🎯', 'usr_1'),
('b_3', 'Curious Mind', '🧠', 'usr_2')
ON CONFLICT (id) DO NOTHING;

-- 9. Insert Notifications
INSERT INTO "Notification" (id, type, message, link, "userId") VALUES 
('n_1', 'ANSWER', 'Carol Davis answered your question about React Fiber', '/questions/q_1', 'usr_2'),
('n_2', 'ACCEPTED', 'Your answer was accepted! +25 reputation', '/questions/q_1', 'usr_3')
ON CONFLICT (id) DO NOTHING;
